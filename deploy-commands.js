const { REST, Routes, SlashCommandBuilder, PermissionFlagsBits } = require('discord.js');
const config = require('./config.json');

// قراءة التوكن من Environment Variables أو من config.json
const token = process.env.TOKEN || config.token;

const commands = [
  new SlashCommandBuilder()
    .setName('help')
    .setDescription('عرض قائمة المساعدة وجميع أوامر البوت'),

  new SlashCommandBuilder()
    .setName('getkey')
    .setDescription('الحصول على كود تفعيل السكربت'),

  new SlashCommandBuilder()
    .setName('resetkey')
    .setDescription('إعادة ضبط ربط الجهاز (HWID Reset) لكودك الحالي'),

  new SlashCommandBuilder()
    .setName('status')
    .setDescription('التحقق من حالة السكربت الحالية'),

  new SlashCommandBuilder()
    .setName('genkey')
    .setDescription('[أدمن] توليد كود مخصص')
    .setDefaultMemberPermissions(PermissionFlagsBits.Administrator)
    .addIntegerOption(option =>
      option.setName('hours')
        .setDescription('مدة الكود بالساعات')
        .setRequired(true))
    .addUserOption(option =>
      option.setName('target')
        .setDescription('المستخدم المراد إعطاؤه الكود (اختياري)')
        .setRequired(false)),

  new SlashCommandBuilder()
    .setName('blacklist')
    .setDescription('[أدمن] إضافة أو إزالة مستخدم من القائمة السوداء')
    .setDefaultMemberPermissions(PermissionFlagsBits.Administrator)
    .addStringOption(option =>
      option.setName('action')
        .setDescription('الإجراء')
        .setRequired(true)
        .addChoices(
          { name: 'إضافة (Add)', value: 'add' },
          { name: 'إزالة (Remove)', value: 'remove' }
        ))
    .addUserOption(option =>
      option.setName('user')
        .setDescription('المستخدم')
        .setRequired(true))
    .addStringOption(option =>
      option.setName('reason')
        .setDescription('السبب')
        .setRequired(false)),

  new SlashCommandBuilder()
    .setName('setstatus')
    .setDescription('[أدمن] تغيير حالة السكربت')
    .setDefaultMemberPermissions(PermissionFlagsBits.Administrator)
    .addStringOption(option =>
      option.setName('state')
        .setDescription('الحالة الجديدة للسكربت')
        .setRequired(true)
        .addChoices(
          { name: '🟢 شغال (Working)', value: 'working' },
          { name: '🟡 قيد التحديث (Updating)', value: 'updating' },
          { name: '🔴 موقوف (Patched)', value: 'patched' }
        ))
    .addStringOption(option =>
      option.setName('message')
        .setDescription('رسالة توضيحية للمستخدمين')
        .setRequired(false)),

  new SlashCommandBuilder()
    .setName('stats')
    .setDescription('[أدمن] عرض إحصائيات البوت والمفاتيح')
    .setDefaultMemberPermissions(PermissionFlagsBits.Administrator)
].map(command => command.toJSON());

const rest = new REST({ version: '10' }).setToken(token);

(async () => {
  try {
    console.log('⏳ جاري تسجيل أوامر السلاش (Slash Commands)...');
    await rest.put(
      Routes.applicationCommands(config.clientId),
      { body: commands }
    );
    console.log('✅ تم تسجيل جميع الأوامر بنجاح!');
  } catch (error) {
    console.error('❌ حدث خطأ أثناء تسجيل الأوامر:', error);
  }
})();
