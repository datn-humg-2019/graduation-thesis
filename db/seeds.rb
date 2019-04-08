if User.where(email: "admin@gmail.com", role: "admin").blank?
  User.create!(
    email: "admin@gmail.com",
    phone: "0364868558",
    password: "123456",
    name: "admin",
    gender: true,
    birth: "1990/01/30",
    adress: "Ha Noi"
  )
end

User.create!(
  email: "vip@gmail.com",
  phone: "0364868501",
  password: "123456",
  name: "user",
  gender: true,
  adress: "Ha Noi",
  birth: "1990/01/30",
  role: 1
)
