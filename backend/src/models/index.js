const sequelize = require('../config/database');
const User = require('./User');
const Country = require('./Country');
const SocialAccount = require('./SocialAccount');
const PasswordReset = require('./PasswordReset');

// Associations
User.belongsTo(Country, { foreignKey: 'country_id' });
Country.hasMany(User, { foreignKey: 'country_id' });

User.hasMany(SocialAccount, { foreignKey: 'user_id' });
SocialAccount.belongsTo(User, { foreignKey: 'user_id' });

module.exports = {
  sequelize,
  User,
  Country,
  SocialAccount,
  PasswordReset,
};
