require "rails_helper"

RSpec.describe "Routes: ", type: :routing do
  it "Get request to / directs to pages#home" do
    expect(get("/")).
      to route_to("pages#home")
  end
end

RSpec.describe "Devise routes: ", type: :routing do
  it "Get request to /users/sign_in directs to devise/sessions#new" do
    expect(get("/users/sign_in")).
      to route_to("devise/sessions#new")
  end
  it "POST request to /users/sign_in directs to devise/sessions#create" do
      expect(post("/users/sign_in")).
        to route_to("devise/sessions#create")
    end

  it "DELETE request to /users/sign_out directs to devise/sessions#destroy" do
    expect(get("/users/sign_in")).
      to route_to("devise/sessions#new")
  end

  it "GET request to /users/password/new directs to devise/passwords#new" do
    expect(get("/users/password/new")).
      to route_to("devise/passwords#new")
  end

  it "GET request to /users/password/edit directs to devise/passwords#edit" do
    expect(get("/users/password/edit")).
      to route_to("devise/passwords#edit")
  end

  it "PATCH request to /users/password directs to devise/passwords#update" do
    expect(patch("/users/password")).
      to route_to("devise/passwords#update")
  end

  it "PUT request to /users/password directs to devise/passwords#update" do
    expect(put("/users/password")).
      to route_to("devise/passwords#update")
  end

  it "POST request to /users/password directs to devise/passwords#create" do
    expect(post("/users/password")).
      to route_to("devise/passwords#create")
  end

  it "GET request to /users/cancel directs to devise/registrations#cancel" do
    expect(get("/users/cancel")).
      to route_to("devise/registrations#cancel")
  end


  it "GET request to /users/sign_up directs to devise/registrations#new" do
    expect(get("/users/sign_up")).
      to route_to("devise/registrations#new")
  end

  it "GET request to /users/edit directs to devise/registrations#edit" do
    expect(get("/users/edit")).
      to route_to("devise/registrations#edit")
  end

  it "PATCH request to /users directs to devise/registrations#update" do
    expect(patch("/users")).
      to route_to("devise/registrations#update")
  end

  it "PUT request to /users directs to devise/registrations#update" do
    expect(put("/users")).
      to route_to("devise/registrations#update")
  end

  it "DELETE /users directs to devise/registrations#destroy" do
    expect(delete("/users")).
      to route_to("devise/registrations#destroy")
  end

  it "POST request to /users directs to devise/registrations#create" do
    expect(post("/users")).
      to route_to("devise/registrations#create")
  end
end
