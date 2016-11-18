import MenuLink from 'discourse/plugins/navigation/discourse/models/menu-link';
import { bufferedProperty } from 'discourse/mixins/buffered-content';

export default Ember.Component.extend(bufferedProperty('menuLink'), {
  editing: Ember.computed.empty('menuLink.id'),
  classNameBindings: [':menu-link']
});
