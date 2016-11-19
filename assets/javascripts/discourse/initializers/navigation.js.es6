import { withPluginApi } from 'discourse/lib/plugin-api';

export default {
  name: 'navigation',

  initialize(container) {
    withPluginApi('0.4', api => {
      const store = container.lookup('store:main');
      store.findAll('menu-link').then(function(rs) {
        var links = [];
        rs.content.forEach(function(l) {
          links.push({ href: l.url, rawLabel: l.name })
        });
        api.decorateWidget("hamburger-menu:generalLinks", () => {
          return links;
        });
      });
    });
  }
};

