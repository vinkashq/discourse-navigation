import MenuLink from 'discourse/plugins/navigation/admin/models/menu-link';

export default Discourse.Route.extend({

  model() {
    return this.store.find('menu_link');
  }

});
