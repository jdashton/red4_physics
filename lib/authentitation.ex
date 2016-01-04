defmodule Authentication do

  def login({:local, login: login, password: password}) do
    #login with login/pass
  end

  def login({:github, token: token, details: details}) do
    #login with OAuth and Github
  end

  def login({:google, url: url, account: account}) do
    #login with OAuth and Google
  end

  def register(%{login: login, password: password} = params) do
    {:ok, login: login, first: params[:first], last: params[:last]}
  end

end
