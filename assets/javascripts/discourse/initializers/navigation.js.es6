import { withPluginApi } from 'discourse/lib/plugin-api';

export default {
  name: 'navigation',
  hamburger_general: [],
  hamburger_footer: [],
  brand_general: [],
  brand_social: [],

  initialize(container) {
    var self = this;
    withPluginApi('0.4', api => {
      api.decorateWidget("hamburger-menu:generalLinks", () => {
        return self.hamburger_general;
      });
      api.decorateWidget("hamburger-menu:footerLinks", () => {
        return self.hamburger_footer;
      });
      api.decorateWidget("brand-header:generalLinks", () => {
        return self.brand_general;
      });
      api.decorateWidget("brand-header:socialIcons", () => {
        return self.brand_social;
      });
      const store = container.lookup('store:main');
      store.findAll('menu-link').then(function(rs) {
        rs.content.forEach(function(l) {
          if(l.visible_hamburger_general) {
            self.hamburger_general.push({ href: l.url, rawLabel: l.name });
          }
          if (l.visible_hamburger_footer) {
            self.hamburger_footer.push({ href: l.url, rawLabel: l.name });
          }
          if(l.visible_brand_general) {
            self.brand_general.push({ href: l.url, rawLabel: l.name });
          }
          if (l.visible_brand_social) {
            self.brand_social.push({ href: l.url, rawLabel: l.name });
          }
        });
      });
    });
  }
};
