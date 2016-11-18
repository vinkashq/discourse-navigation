# name: navigation
# about: Plugin to add a custom nav menu links
# version: 0.0.1
# authors: Vinoth Kannan (vinothkannan@vinkas.com)
# url: https://github.com/vinkas0/discourse-navigation

add_admin_route 'navigation.title', 'navigation'

PLUGIN_NAME ||= "navigation".freeze
STORE_NAME ||= "menu_links".freeze

after_initialize do

  module ::Navigation
    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace Navigation
    end
  end

  class Navigation::MenuLink
    class << self

      def add(user_id, name, url)
        ensureAdmin user_id

        # TODO add i18n string
        raise StandardError.new "menu_links.missing_name" if name.blank?
        raise StandardError.new "menu_links.missing_url" if url.blank?

        id = SecureRandom.hex(16)
        record = {id: id, name: name, url: url}

        menu_links = PluginStore.get(PLUGIN_NAME, STORE_NAME)
        menu_links = Hash.new if menu_links == nil

        menu_links[id] = record
        PluginStore.set(PLUGIN_NAME, STORE_NAME, menu_links)

        record
      end

      def all
        menu_links = PluginStore.get(PLUGIN_NAME, STORE_NAME)

        return [] if menu_links.blank?

        menu_links.each do |id, value|
          menu_links[id] = value
        end

        menu_links
      end

      def ensureAdmin (user_id)
        user = User.find_by(id: user_id)

        unless user.try(:admin?)
          raise StandardError.new "menu_links.must_be_staff"
        end
      end

    end
  end

  require_dependency "application_controller"

  class Navigation::MenulinksController < ::ApplicationController
    requires_plugin PLUGIN_NAME

    def create
      field_params = params.require(:menu_link)
      name   = field_params[:name]
      url = field_params[:url]
      user_id   = current_user.id

      begin
        record = Navigation::MenuLink.add(user_id, name, url)
        render json: record
      rescue StandardError => e
        render_json_error e.message
      end
    end

    def index
      begin
        menu_links = Navigation::MenuLink.all()
        render json: {menu_links: menu_links}
      rescue StandardError => e
        render_json_error e.message
      end
    end

  end

  Navigation::Engine.routes.draw do
    get "/menu_links" => "menulinks#index"
    post "/menu_links" => "menulinks#create"
  end

  Discourse::Application.routes.append do
    get '/admin/plugins/navigation' => 'admin/plugins#index', constraints: StaffConstraint.new
    mount ::Navigation::Engine, at: "/"
  end

end
