if User.where(email: "admin@gmail.com", role: "admin").blank?
  User.create!(
    email: "admin@gmail.com",
    phone: "0123456789",
    user_code: "a01",
    password: "111111",
    name: "admin",
    gender: true,
    adress: "Ha Noi"
  )
end
