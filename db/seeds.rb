TestRecord.find_or_create_by(name: 'test_here')

user_id_for_test = 16195

['+5510999999999', '+5510999999998', '+5510999999997', '+5510999999996', '+5510999999995'].each do |phone_number|
  phone = Phone.find_by(user_id: user_id_for_test, phone: phone_number)

  if phone.blank?
    phone = Phone.create(user_id: user_id_for_test, phone: phone_number)

    if phone.present?
      amount = [5, 12, 20, 50, 70].sample
      recharge = Recharge.find_by(user_id: user_id_for_test, phone_id: phone.id)
      if recharge.blank?
        Recharge.create(user_id: user_id_for_test, phone_id: phone.id, amount: amount)
      end
    end
  end
end
