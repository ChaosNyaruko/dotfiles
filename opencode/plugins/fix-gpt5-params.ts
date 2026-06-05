/**
 * Plugin: fix-gpt5-params
 *
 * gpt-5.x models require `max_completion_tokens` instead of `max_tokens`,
 * and do not support `frequency_penalty` / `presence_penalty`.
 * The @ai-sdk/openai-compatible SDK always sends `max_tokens`, which causes:
 *   "Unsupported parameter: 'max_tokens' is not supported with this model"
 *
 * This plugin patches the global fetch to rewrite request bodies going to
 * the all-in-one proxy endpoint before they hit the wire.
 */

import type { Plugin } from "@opencode-ai/plugin"

const TARGET_HOST = "all-in-one-ai.fintopia.tech"

const originalFetch = globalThis.fetch

globalThis.fetch = async function patchedFetch(
  input: RequestInfo | URL,
  init?: RequestInit,
): Promise<Response> {
  const url = typeof input === "string" ? input : input instanceof URL ? input.href : input.url

  if (url.includes(TARGET_HOST) && init?.body && typeof init.body === "string") {
    try {
      const body = JSON.parse(init.body)
      let modified = false

      // Rewrite max_tokens -> max_completion_tokens
      if ("max_tokens" in body && !("max_completion_tokens" in body)) {
        body.max_completion_tokens = body.max_tokens
        delete body.max_tokens
        modified = true
      }

      // Remove unsupported parameters for gpt-5.x on /chat/completions
      for (const param of ["frequency_penalty", "presence_penalty", "logprobs", "top_logprobs", "reasoning_effort", "reasoning_summary"]) {
        if (param in body) {
          delete body[param]
          modified = true
        }
      }

      if (modified) {
        init = { ...init, body: JSON.stringify(body) }
      }
    } catch {
      // Not JSON or parse error — leave body untouched
    }
  }

  return originalFetch(input, init)
} as typeof globalThis.fetch

export const server: Plugin = async () => {
  return {}
}
