{
  lsp.servers.omnisharp = {
    enable = true;

    # https://github.com/OmniSharp/omnisharp-roslyn/wiki/Configuration-Options
    settings = {
      FormattingOptions = {
        TabSize = 2;
        IndentationSize = 2;
      };

      RoslynExtensionsOptions = {
        enableDecompilationSupport = true;
        enableImportCompletion = true;
        enableAnalyzersSupport = true;

        inlayHintsOptions = {
          enableForParameters = true;
          forLiteralParameters = true;
          forIndexerParameters = true;
          forObjectCreationParameters = true;
          forOtherParameters = true;
          suppressForParametersThatDifferOnlyBySuffix = false;
          suppressForParametersThatMatchMethodIntent = false;
          suppressForParametersThatMatchArgumentName = false;
          enableForTypes = true;
          forImplicitVariableTypes = true;
          forLambdaParameterTypes = true;
          forImplicitObjectCreation = true;
        };
      };
    };
  };
}
