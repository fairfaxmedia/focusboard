# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


if Rails.env == 'development'
  User.create!(
    email: 'admin@example.com',
    name: 'Admin',
    password: 'password',
    password_confirmation: 'password',
    admin: true,
    enabled: true
  )
  User.create!(email: 'adam@example.com',
    name: 'Adam',
    password: 'password',
    password_confirmation: 'password',
    admin: false,
    enabled: true
  )
  User.create!(
    email: 'bob@example.com',
    name: 'Bob',
    password: 'password',
    password_confirmation: 'password',
    admin: false,
    enabled: true
  )
  User.create!(
    email: 'cameron@example.com',
    name: 'Cameron',
    password: 'password',
    password_confirmation: 'password',
    admin: false,
    enabled: true
  )
  User.create!(
    email: 'dennis@example.com',
    name: 'Dennis',
    password: 'password',
    password_confirmation: 'password',
    admin: false,
    enabled: true
  )
  User.create!(
    email: 'elaine@example.com',
    name: 'Elaine',
    password: 'password',
    password_confirmation: 'password',
    admin: false,
    enabled: true
  )
  User.create!(
    email: 'fred@example.com',
    name: 'Fred',
    password: 'password',
    password_confirmation: 'password',
    admin: false,
    enabled: true
  )
  User.create!(
    email: 'greg@example.com',
    name: 'Greg',
    password: 'password',
    password_confirmation: 'password',
    admin: false,
    enabled: true
  )
  User.create!(
    email: 'henry@example.com',
    name: 'Henry',
    password: 'password',
    password_confirmation: 'password',
    admin: false,
    enabled: true
  )

  batops_board = Board.create!(name: 'BatOps', owner: admin)
  User.all.each { |user| batops_board.users << user }
  User.all.each do |user|
    3.times do |n|
      task = user.tasks.create!(
        title: "#{user.name}'s task #{n}",
        description: "sample task",
        status: "active",
        board: batops_board,
        created_at: n.days.ago
      )
      task.task_statuses << TaskStatus.new(status: :active)
    end

    %w(bumped priority wasted blocked).each do |status|
      task = user.tasks.create!(
        title: "#{user.name}'s #{status} task",
        description: "sample task",
        status: status,
        board: batops_board
      )
      task.task_statuses << TaskStatus.new(status: status)
    end
  end
elsif rails.env == 'production'
  User.create!(
    email: 'admin@example.com.au',
    name: 'Admin',
    password: 'password',
    password_confirmation: 'password',
    admin: true,
    enabled: true
  )
end
