local java21_bin = "/opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home/bin/java"

---@type vim.lsp.Config
return {
    -- jdtls itself requires Java 21+; pass the executable directly so it
    -- doesn't rely on JAVA_HOME or PATH.
    cmd = {
        "jdtls",
        "--java-executable", java21_bin,
        "--jvm-arg=-javaagent:" .. vim.fn.expand("~/.m2/repository/org/projectlombok/lombok/1.18.30/lombok-1.18.30.jar"),
    },
    filetypes = { "java" },
    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        on_dir(
            vim.fs.root(fname, { "pom.xml", "build.gradle", "build.gradle.kts", ".git" })
        )
    end,
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-25",
                        path = "/opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home",
                        default = true,
                    },
                },
            },
            -- Treat source as Java 8 for analysis
            source = { organizeImports = true },
            project = {
                sourceCompatibility = "1.8",
                targetCompatibility = "1.8",
            },
        },
    },
}
