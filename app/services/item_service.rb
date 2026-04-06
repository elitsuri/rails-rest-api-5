class ItemService
  def self.list_for_user(user, filters = {})
    scope = user.admin? ? Item.all : Item.for_user(user)
    scope = scope.where(status: filters[:status])       if filters[:status].present?
    scope = scope.search(filters[:q])                   if filters[:q].present?
    sort  = filters[:sort_by] || 'created_at'
    dir   = filters[:sort_dir] || 'desc'
    scope.order("#{sort} #{dir}").recent
  end

  def self.create(user, params)
    item = user.items.build(params)
    item.save!
    Notification.create!(user: user, kind: 'item_created',
      message: "Item '#{item.title}' was created.", notifiable: item)
    item
  end

  def self.update(item, params, user)
    item.update!(params)
    Notification.create!(user: user, kind: 'item_updated',
      message: "Item '#{item.title}' was updated.", notifiable: item)
    item
  end
end
