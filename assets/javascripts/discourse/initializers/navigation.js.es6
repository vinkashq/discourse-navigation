import { withPluginApi } from 'discourse/lib/plugin-api';

function initialize(api) {
  var result = this.store.findAll('menu-link');
  var links = [];
  for (var ml in result) {
    links.push({ href: ml.url, rawLabel: ml.name })
  }
  api.decorateWidget("hamburger-menu:generalLinks", () => {
      return links;
  });
}

export default {
  name: 'navigation',

  initialize(container) {
    withPluginApi('0.4', api => initialize);
  }
}
