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
      const m = this.store.createRecord('menu-link', { position: MAX_FIELDS });
      this.get('model').pushObject(m);
    }
  }

});
