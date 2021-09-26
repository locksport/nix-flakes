{
  description = "Flake packages";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.deta = pkgs.callPackage (
          { buildGoModule, fetchFromGitHub }:
          buildGoModule rec {
            pname = "deta";
            version = "1.2.0-beta";

            src = fetchFromGitHub {
              owner = "deta";
              repo = "deta-cli";
              rev = "v${version}";
              sha256 = "sha256-SSiMHpc/yuKCx2qTU77uikoSMLzjNh68G3jkkx97vSM=";
            };

            DETA_VERSION = "v${version}";
            GATEWAY_DOMAIN = "deta.dev";
            VISOR_URL = "https://visor.deta.dev";
            LOGIN_URL = "https://web.deta.sh/cli";
            COGNITO_CLIENT_ID = "4io3aeqf1h967ufalk5n742cfj";
            COGNITO_REGION = "eu-central-1";
            DETA_SIGN_VERSION = "v0";
            TARGET_PLATFORM = system;

            ldflags = [
              "-X github.com/deta/deta-cli/cmd.detaVersion=${DETA_VERSION}"
              "-X github.com/deta/deta-cli/cmd.gatewayDomain=${GATEWAY_DOMAIN}"
              "-X github.com/deta/deta-cli/cmd.visorURL=${VISOR_URL}"
              "-X github.com/deta/deta-cli/auth.loginURL=${LOGIN_URL}"
              "-X github.com/deta/deta-cli/auth.cognitoClientID=${COGNITO_CLIENT_ID}"
              "-X github.com/deta/deta-cli/auth.cognitoRegion=${COGNITO_REGION}"
              "-X github.com/deta/deta-cli/auth.detaSignVersion=${DETA_SIGN_VERSION}"
              "-X github.com/deta/deta-cli/api.version=${DETA_VERSION}"
              "-X github.com/deta/deta-cli/cmd.platform=${TARGET_PLATFORM}"
            ];

            vendorSha256 = "sha256-bkvSGEmBbeoQ0Y46n7RVwzc9nFU7gq4kkWEuRmBrtHQ=";
            #runVend = true;

            fixupPhase = /* sh */ ''
              mv $out/bin/deta-cli $out/bin/deta
            '';
          }
        ) {};
      }
    );
  }
