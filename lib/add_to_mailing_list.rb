class AddToMailingList
  def perform
    gb = Gibbon.new
    id = gb.lists['data'].select {|list| list['name'] == 'BA Promotions'}.first.id
    Lead.where('created_at >= ?', Date.today).each do |lead|
      gb.list_subscribe(:id => id, :email_address => lead.email_address)
    end
  end
end