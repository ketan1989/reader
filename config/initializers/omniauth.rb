Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, GOOGLE_KEY, GOOGLE_SECRET,
           {
             :scope => "userinfo.email,userinfo.profile,https://www.google.com/reader/api,plus.me",
             :approval_prompt => "auto",
             access_type: "offline"
           }
end