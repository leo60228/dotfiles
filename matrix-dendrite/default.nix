{ lib, buildGoModule, fetchFromGitHub}:

buildGoModule rec {
  pname = "matrix-dendrite";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "dendrite";
    rev = "v${version}";
    sha256 = "0390z5pavhw4jnnd3ddxhp09r4zfl9wp6lj35ks6vjl23fxxw66w";
  };

  vendorSha256 = "1fjkjjhhm83qlh3mj4nda3r6qnrz3izscxjxgbl7j81w0c2qqkfi";

  meta = with lib; {
    homepage = "https://matrix.org";
    description = "Dendrite is a second-generation Matrix homeserver written in Go!";
    license = licenses.asl20;
    maintainers = teams.matrix.members;
    platforms = platforms.unix;
  };
}
