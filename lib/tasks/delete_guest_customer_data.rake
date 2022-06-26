namespace :delete_guest_customer_data do
  desc "delete_guest_customer_data"
	task destroy: :environment do
		customer = Customer.find_by(email: "guest@example.com")
    customer.tasks.destroy_all
    customer.task_comments.destroy_all
	end
end
