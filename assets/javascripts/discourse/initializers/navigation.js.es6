import { withPluginApi } from 'discourse/lib/plugin-api';

export default {
  name: 'navigation',
  links: [],

  initialize(container) {
    var self = this;
    withPluginApi('0.4', api => {
        Discourse.MenuItem = Discourse.NavItem.extend({
          href : function() {
            return this.get('href');
          }.property('href'),
displayName : function() {
  return this.get('name');
}.property('name')
        });
        Discourse.NavItem.reopenClass({
          buildList : function(category, args) {
            var list = this._super(category, args);

            self.links.forEach(function(l) {
              list.push(Discourse.MenuItem.create({ href: l.url, name: l.rawLabel} ));
            });

            return list;
          }
        });
        api.decorateWidget("hamburger-menu:generalLinks", () => {
          return self.links;
        });
      const store = container.lookup('store:main');
      store.findAll('menu-link').then(function(rs) {
        rs.content.forEach(function(l) {
          self.links.push({ href: l.url, rawLabel: l.name });
        });
      });
    });
  }
};
