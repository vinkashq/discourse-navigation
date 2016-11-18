import MenuLink from 'discourse/plugins/navigation/discourse/models/menu-link';

export default Ember.Controller.extend({

  arrangedContent: function() {
    return Ember.ArrayProxy.extend(Ember.SortableMixin).create({
      sortProperties: ['position'],
      content: this.get('model')
    });
  }.property('model')

});
