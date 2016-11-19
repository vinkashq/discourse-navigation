
Discourse.MenuItem = Discourse.NavItem.extend({
  href : function() {
    return this.get('href');
  }.property('href'),

  name : function() {
    return this.get('name');
  }.property('name')
});

export default Discourse.MenuItem;
