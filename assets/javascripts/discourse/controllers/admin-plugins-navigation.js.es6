import MenuLink from 'discourse/plugins/navigation/discourse/models/menu-link';

const MAX_FIELDS = 100;

export default Ember.Controller.extend({
  createDisabled: Em.computed.gte('model.length', MAX_FIELDS),

  arrangedContent: function() {
    return Ember.ArrayProxy.extend(Ember.SortableMixin).create({
      sortProperties: ['position'],
      content: this.get('model')
    });
  }.property('model'),

  actions: {
    createMenu() {
      const m = this.store.createRecord('menu-link', { position: 0 });
      this.get('model').pushObject(m);
    },

    destroy(f) {
      const model = this.get('model');

      // Only confirm if we already been saved
      if (f.get('id')) {
        bootbox.confirm(I18n.t("admin.user_fields.delete_confirm"), function(result) {
          if (result) {
            f.destroyRecord().then(function() {
              model.removeObject(f);
            }).catch(popupAjaxError);
          }
        });
      } else {
        model.removeObject(f);
      }
    }
  }

});
