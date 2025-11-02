defmodule LeftNoteServer.Token do
  use Joken.Config

  def get_signer!() do
    Joken.Signer.create("RS256", %{"pem" => File.read!("private.pem")})
  end

  def get_verifier!() do
    Joken.Signer.create("RS256", %{"pem" => File.read!("public.pem")})
  end
end
