if User.where(email: "admin@gmail.com", role: "admin").blank?
  User.create!(
    email: "admin@gmail.com",
    phone: "0123456789",
    password: "111111",
    name: "admin",
    gender: true,
    adress: "Ha Noi"
  )
end

User.create!(
  email: "user@gmail.com",
  phone: "0123456788",
  password: "111111",
  name: "user",
  gender: true,
  adress: "Ha Noi",
  role: 1
)
