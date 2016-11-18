import MenuLink from 'discourse/plugins/navigation/discourse/models/menu-link';
import { bufferedProperty } from 'discourse/mixins/buffered-content';
import { popupAjaxError } from 'discourse/lib/ajax-error';

export default Ember.Component.extend(bufferedProperty('menuLink'), {
  editing: Ember.computed.empty('menuLink.id'),
  classNameBindings: [':menu-link'],

  actions: {
    save() {
      const self = this;
      const buffered = this.get('buffered');
      const attrs = buffered.getProperties('name',
                                           'url',
                                           'hamburger_general',
                                           'hamburger_footer');

      this.get('menuLink').save(attrs).then(function() {
        self.set('editing', false);
        self.commitBuffer();
      }).catch(popupAjaxError);
    },

    cancel() {
      const id = this.get('menuLink.id');
      if (Ember.isEmpty(id)) {
        this.sendAction('destroyAction', this.get('menuLink'));
      } else {
        this.rollbackBuffer();
        this.set('editing', false);
      }
    }
});
