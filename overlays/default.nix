{ self }:
{
  default = final: prev: {
    prisma-language-server = self.packages.${prev.system}.prisma-language-server;
    gh-actions-language-server = self.packages.${prev.system}.gh-actions-language-server;
  };
}
