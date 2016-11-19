import { withPluginApi } from 'discourse/lib/plugin-api';

export default {
  name: 'navigation',
  links: [],

  initialize(container) {
    var self = this;
    withPluginApi('0.4', api => {
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
