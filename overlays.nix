{ inputs }:
{
  default = final: prev: {
    npm-ls = inputs.self.packages.${prev.system}.npm-ls;
    prisma-language-server = inputs.self.packages.${prev.system}.prisma-language-server;
    gh-actions-language-server = inputs.self.packages.${prev.system}.gh-actions-language-server;
  };
}
