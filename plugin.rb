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

      def add(user_id, name, url, visible)
        ensureAdmin user_id

        # TODO add i18n string
        raise StandardError.new "menu_links.missing_name" if name.blank?
        raise StandardError.new "menu_links.missing_url" if url.blank?

        menu_links = PluginStore.get(PLUGIN_NAME, STORE_NAME)
        menu_links = Hash.new if menu_links == nil

        id = SecureRandom.hex(16)
        record = {id: id, name: name, url: url, visible: visible}
        max = menu_links.map { |d| d[:position] }.max
        record['position'] = (max || 0) + 1

        menu_links[id] = record
        PluginStore.set(PLUGIN_NAME, STORE_NAME, menu_links)

        record
      end

      def edit(user_id, id, name, url, visible)
        ensureAdmin user_id

        raise StandardError.new "menu_links.missing_name" if name.blank?
        raise StandardError.new "menu_links.missing_url" if url.blank?

        menu_links = PluginStore.get(PLUGIN_NAME, STORE_NAME)
        menu_links = Hash.new if menu_links == nil

        record = menu_links[id]
        record['name'] = name
        record['url'] = url
        record['visible'] = visible

        menu_links[id] = record
        PluginStore.set(PLUGIN_NAME, STORE_NAME, menu_links)

        record
      end

      def move(user_id, id, position)
        ensureAdmin user_id

        raise StandardError.new "menu_links.missing_position" if position.blank?

        menu_links = PluginStore.get(PLUGIN_NAME, STORE_NAME)
        menu_links = Hash.new if menu_links == nil

        record = menu_links[id]
        record['position'] = position

        menu_links[id] = record
        PluginStore.set(PLUGIN_NAME, STORE_NAME, menu_links)

        record
      end

      def remove(user_id, id)
        ensureAdmin user_id

        menu_links = PluginStore.get(PLUGIN_NAME, STORE_NAME)
        menu_links.delete id
        PluginStore.set(PLUGIN_NAME, STORE_NAME, menu_links)
      end

      def all
        menu_links = Array.new
        result = PluginStore.get(PLUGIN_NAME, STORE_NAME)

        return menu_links if result.blank?

        result.each do |id, value|
          menu_links.push(value)
        end

        menu_links
      end

      def ensureAdmin (user_id)
        user = User.find_by(id: user_id)

        unless user.try(:admin?)
          raise StandardError.new "menu_links.must_be_admin"
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
      hamburger = {general: field_params[:hamburger_general], footer: field_params[:hamburger_footer]}
      visible = {hamburger: hamburger}
      user_id   = current_user.id

      begin
        record = Navigation::MenuLink.add(user_id, name, url, visible)
        render json: record
      rescue StandardError => e
        render_json_error e.message
      end
    end

    def remove
      field_params = params.require(:menu_link)
      id = params.require(:id)
      user_id  = current_user.id

      begin
        record = Navigation::MenuLink.remove(user_id, id)
        render json: record
      rescue StandardError => e
        render_json_error e.message
      end
    end

    def update
      id = params.require(:id)
      position = params[:position]
      if position.nil?
        field_params = params.require(:menu_link)
        name   = field_params[:name]
        url = field_params[:url]
        hamburger = {general: field_params[:hamburger_general], footer: field_params[:hamburger_footer]}
        visible = {hamburger: hamburger}
        user_id  = current_user.id

        begin
          record = Navigation::MenuLink.edit(user_id, id, name, url, visible)
          render json: record
        rescue StandardError => e
          render_json_error e.message
        end
      else
        begin
          record = Navigation::MenuLink.move(user_id, id, position)
          render json: record
        rescue StandardError => e
          render_json_error e.message
        end
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
    delete "/menu_links/:id" => "menulinks#remove"
    put "/menu_links/:id" => "menulinks#update"
  end

  Discourse::Application.routes.append do
    get '/admin/plugins/navigation' => 'admin/plugins#index', constraints: StaffConstraint.new
    mount ::Navigation::Engine, at: "/"
  end

end
