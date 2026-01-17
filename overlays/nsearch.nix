{ nsearch }:
final: prev: {
  nsearch = nsearch.packages.${prev.stdenv.hostPlatform.system}.nsearch-adv;
}

