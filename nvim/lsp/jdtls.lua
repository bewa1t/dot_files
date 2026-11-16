-- Java: Eclipse JDT LS, optional (setup/jdtls.sh builds it). The `jdtls` launcher
-- (utils/jdtls/jdtls) sets the heap and the workspace folder. jdtls reads the
-- settings from initializationOptions.settings.
local dot = vim.fs.dirname(vim.fn.resolve(vim.fn.stdpath('config')))
local java_dir = vim.fn.expand('~/.sdkman/candidates/java/')

-- The top-most Gradle/Maven build root inside the git repository, so nested
-- builds (buildSrc, included builds) share one jdtls instead of starting a
-- second one (1.8 GB) on the same workspace folder.
local build_markers = { 'settings.gradle', 'settings.gradle.kts', 'pom.xml' }
local function root_dir(bufnr, on_dir)
  local path = vim.api.nvim_buf_get_name(bufnr)
  local repo = vim.fs.root(path, '.git')
  local top
  for dir in vim.fs.parents(path) do
    for _, marker in ipairs(build_markers) do
      if vim.uv.fs_stat(vim.fs.joinpath(dir, marker)) then top = dir end
    end
    if dir == repo then break end
  end
  on_dir(top or repo)
end

return {
  -- started in the root folder: the launcher names the workspace folder after it
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({ 'jdtls' }, dispatchers, { cwd = config.root_dir })
  end,
  filetypes = { 'java' },
  root_dir = root_dir,
  init_options = { settings = { java = {
    -- compiler settings: no "unnecessary @SuppressWarnings"
    settings = { url = dot .. '/utils/jdtls/jdtls.prefs' },
    import = { gradle = {
      -- Gradle runs on jdtls's Java (25) unless the build asks for another JDK.
      -- The annotation-processing sync fails on Gradle 9.7 ("resolution ...
      -- without an exclusive lock"); Elasticsearch commits its generated sources.
      annotationProcessing = { enabled = false },
      -- Without -Xmx, Elasticsearch gives the daemon 1/4 of RAM; 1 GB thrashes.
      -- It stops 60 s after the import, so jdtls (5 GB) + Gradle stay under 7 GB.
      jvmArguments = { '-Xmx2g', '-XX:MaxMetaspaceSize=768m' },
      arguments = {
        -- mark the Java modules of modular projects for Eclipse
        '--init-script', dot .. '/utils/jdtls/eclipse-modules.gradle',
        '-Dorg.gradle.daemon.idletimeout=60000',
      },
    } },
    configuration = { runtimes = {
      { name = 'JavaSE-21', path = java_dir .. '21.0.11-tem', default = true },
      { name = 'JavaSE-25', path = java_dir .. '25.0.3-tem' },
    } },
  } } },
}
