# name: navigation
# about: Plugin to add a custom nav menu links
# version: 0.0.1
# authors: Vinoth Kannan (vinothkannan@vinkas.com)
# url: https://github.com/vinkas0/discourse-navigation

add_admin_route 'navigation.title', 'navigation'

Discourse::Application.routes.append do
  get '/admin/plugins/navigation' => 'admin/plugins#index', constraints: StaffConstraint.new
end
