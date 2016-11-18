import MenuLink from 'discourse/plugins/navigation/models/menu-link';

export default Discourse.Route.extend({

  model() {
    return this.store.find('menu-link');
  }

});
