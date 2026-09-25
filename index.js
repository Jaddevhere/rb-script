const { 
  Client, 
  GatewayIntentBits, 
  EmbedBuilder, 
  ActionRowBuilder, 
  ButtonBuilder, 
  ButtonStyle, 
  PermissionFlagsBits 
} = require('discord.js');
const fs = require('fs');
const http = require('http');
const config = require('./config.json');

// --- خادم Render Keep-Alive ---
const PORT = process.env.PORT || 3000;
http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });
  res.end('RB Script Bot is Running Online 24/7!');
}).listen(PORT, () => {
  console.log(`🌐 تم تشغيل خادم الحفاظ على الاتصال (Keep-Alive) على المنفذ: ${PORT}`);
});

const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMembers,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.DirectMessages
  ]
});

const DB_FILE = './database.json';

function loadDB() {
  if (!fs.existsSync(DB_FILE)) {
    const initialData = {
      keys: {},
      blacklisted: {},
      scriptStatus: {
        status: 'working',
        message: 'السكربت شغال ويعمل بكفاءة عالية على آخر تحديث!'
      },
      stats: { totalGenerated: 0 }
    };
    fs.writeFileSync(DB_FILE, JSON.stringify(initialData, null, 2));
    return initialData;
  }
  return JSON.parse(fs.readFileSync(DB_FILE, 'utf8'));
}

function saveDB(data) {
  fs.writeFileSync(DB_FILE, JSON.stringify(data, null, 2));
}

function generateRandomKey(isVip = false) {
  const prefix = isVip ? 'VIP-TRL' : 'TRL';
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let part1 = '', part2 = '';
  for (let i = 0; i < 4; i++) part1 += chars.charAt(Math.floor(Math.random() * chars.length));
  for (let i = 0; i < 4; i++) part2 += chars.charAt(Math.floor(Math.random() * chars.length));
  return `${prefix}-${part1}-${part2}`;
}

function formatRemainingTime(ms) {
  const totalSeconds = Math.floor(ms / 1000);
  const hours = Math.floor(totalSeconds / 3600);
  const minutes = Math.floor((totalSeconds % 3600) / 60);
  return `${hours} ساعة و ${minutes} دقيقة`;
}

function isAdmin(interaction) {
  if (interaction.guild && interaction.guild.ownerId === interaction.user.id) return true;
  return interaction.memberPermissions && interaction.memberPermissions.has(PermissionFlagsBits.Administrator);
}

async function ensureActiveRole(guild) {
  let role = guild.roles.cache.find(r => r.name === 'Script User');
  if (!role) {
    try {
      role = await guild.roles.create({
        name: 'Script User',
        color: '#00FFFF',
        reason: 'رتبة تلقائية لمستخدمي السكربت النشطين'
      });
    } catch (e) {
      console.error('خطأ أثناء إنشاء الرتبة:', e);
    }
  }
  return role;
}

client.once('ready', () => {
  console.log(`🤖 تم تشغيل البوت بنجاح باسم: ${client.user.tag}`);
  client.user.setActivity('RB Script System | /getkey', { type: 3 });

  setInterval(async () => {
    const db = loadDB();
    const now = Date.now();
    for (const guild of client.guilds.cache.values()) {
      const activeRole = guild.roles.cache.find(r => r.name === 'Script User');
      if (!activeRole) continue;

      for (const [userId, keyData] of Object.entries(db.keys)) {
        if (keyData.expiresAt <= now) {
          try {
            const member = await guild.members.fetch(userId).catch(() => null);
            if (member && member.roles.cache.has(activeRole.id)) {
              await member.roles.remove(activeRole);
            }
          } catch (e) {}
        }
      }
    }
  }, 5 * 60 * 1000);
});

client.on('interactionCreate', async interaction => {
  const db = loadDB();

  if (interaction.isChatInputCommand()) {
    const { commandName } = interaction;

    if (commandName === 'help') {
      const helpEmbed = new EmbedBuilder()
        .setTitle('🤖 قائمة المساعدة - RB Script Bot')
        .setDescription('مرحباً بك في نظام المفاتيح والتحكم الخاص بـ **RB Script**!')
        .addFields(
          { name: '🔑 `/getkey`', value: 'الحصول على كود تفعيل (عبر البوت أو الموقع).' },
          { name: '🔄 `/resetkey`', value: 'إعادة ضبط الجهاز (HWID Reset) لكودك المفعّل.' },
          { name: '📊 `/status`', value: 'معرفة حالة السكربت وهل هو شغال أو قيد التحديث.' },
          { name: '👑 **أوامر الإدارة (Admins)**', value: '`/genkey`, `/blacklist`, `/setstatus`, `/stats`' }
        )
        .setColor('#00FFFF')
        .setThumbnail(client.user.displayAvatarURL())
        .setFooter({ text: 'TRL Key System • جميع الحقوق محفوظة' });

      return interaction.reply({ embeds: [helpEmbed], ephemeral: true });
    }

    if (commandName === 'getkey') {
      if (db.blacklisted[interaction.user.id]) {
        return interaction.reply({
          content: `❌ **أنت محظور من استخدام البوت.**\n**السبب:** ${db.blacklisted[interaction.user.id].reason || 'غير محدد'}`,
          ephemeral: true
        });
      }

      const embed = new EmbedBuilder()
        .setTitle('🔑 نظام أخذ الكود - RB Script Key System')
        .setDescription('اختر الطريقة التي تفضلها للحصول على كود التفعيل الخاص بك:')
        .setColor('#00FFBB')
        .addFields(
          { name: '🌐 عبر الموقع الرسمي', value: 'تخطي المهام البسيطة للحصول على الكود.' },
          { name: '🤖 عبر البوت مباشرة', value: 'توليد كود سريع صالح لمدة 24 ساعة (أو 7 أيام لداعمي السيرفر).' }
        );

      const row = new ActionRowBuilder().addComponents(
        new ButtonBuilder()
          .setLabel('🌐 عبر الموقع')
          .setStyle(ButtonStyle.Link)
          .setURL(config.websiteUrl),
        new ButtonBuilder()
          .setCustomId('get_key_direct')
          .setLabel('🤖 عبر البوت مباشرة')
          .setStyle(ButtonStyle.Success)
      );

      return interaction.reply({ embeds: [embed], components: [row], ephemeral: true });
    }

    if (commandName === 'resetkey') {
      const userKey = db.keys[interaction.user.id];
      if (!userKey || userKey.expiresAt <= Date.now()) {
        return interaction.reply({ content: '❌ ليس لديك كود نشط لإعادة ضبطه.', ephemeral: true });
      }

      const now = Date.now();
      const lastReset = userKey.lastReset || 0;
      const cooldown = 24 * 60 * 60 * 1000;

      if (now - lastReset < cooldown) {
        const remaining = formatRemainingTime(cooldown - (now - lastReset));
        return interaction.reply({
          content: `⏳ يمكنك إعادة ضبط الجهاز مرة واحدة كل 24 ساعة.\nالمتبقي لإتاحة التغيير: **${remaining}**`,
          ephemeral: true
        });
      }

      userKey.hwid = null;
      userKey.lastReset = now;
      saveDB(db);

      return interaction.reply({
        content: '✅ **تم إعادة ضبط الجهاز بنجاح!** يمكنك الآن استخدام الكود على المشغل (Executor) الجديد.',
        ephemeral: true
      });
    }

    if (commandName === 'status') {
      const st = db.scriptStatus;
      let statusIcon = '🟢';
      let statusText = 'شغال (Working)';

      if (st.status === 'updating') { statusIcon = '🟡'; statusText = 'قيد التحديث (Updating)'; }
      if (st.status === 'patched') { statusIcon = '🔴'; statusText = 'موقوف مؤقتاً (Patched)'; }

      const embed = new EmbedBuilder()
        .setTitle('📊 حالة السكربت الحالية - Script Status')
        .addFields(
          { name: 'الحالة:', value: `${statusIcon} **${statusText}**`, inline: true },
          { name: 'ملاحظة الأدمن:', value: st.message || 'لا يوجد' }
        )
        .setColor(st.status === 'working' ? '#00FF00' : st.status === 'updating' ? '#FFFF00' : '#FF0000')
        .setTimestamp();

      return interaction.reply({ embeds: [embed], ephemeral: true });
    }

    if (commandName === 'genkey') {
      if (!isAdmin(interaction)) return interaction.reply({ content: '❌ ليس لديك صلاحية أدمن.', ephemeral: true });

      const hours = interaction.options.getInteger('hours');
      const targetUser = interaction.options.getUser('target');
      const durationMs = hours * 60 * 60 * 1000;
      const generatedKey = generateRandomKey(true);

      if (targetUser) {
        db.keys[targetUser.id] = {
          key: generatedKey,
          expiresAt: Date.now() + durationMs,
          hwid: null,
          lastReset: 0,
          isVip: true
        };
      }
      db.stats.totalGenerated++;
      saveDB(db);

      return interaction.reply({
        content: `✅ **تم توليد الكود بنجاح!**\n🔑 الكود: \`${generatedKey}\`\n⏳ المدة: **${hours} ساعة**${targetUser ? `\n👤 تم تعيينه للمستخدم: <@${targetUser.id}>` : ''}`,
        ephemeral: true
      });
    }

    if (commandName === 'blacklist') {
      if (!isAdmin(interaction)) return interaction.reply({ content: '❌ ليس لديك صلاحية أدمن.', ephemeral: true });

      const action = interaction.options.getString('action');
      const user = interaction.options.getUser('user');
      const reason = interaction.options.getString('reason') || 'بدون سبب';

      if (action === 'add') {
        db.blacklisted[user.id] = { reason, date: Date.now() };
        delete db.keys[user.id];
        saveDB(db);
        return interaction.reply({ content: `✅ تم إضافة <@${user.id}> للقائمة السوداء.`, ephemeral: true });
      } else {
        delete db.blacklisted[user.id];
        saveDB(db);
        return interaction.reply({ content: `✅ تم إزالة <@${user.id}> من القائمة السوداء.`, ephemeral: true });
      }
    }

    if (commandName === 'setstatus') {
      if (!isAdmin(interaction)) return interaction.reply({ content: '❌ ليس لديك صلاحية أدمن.', ephemeral: true });

      const state = interaction.options.getString('state');
      const message = interaction.options.getString('message') || 'لا يوجد';

      db.scriptStatus = { status: state, message };
      saveDB(db);

      return interaction.reply({ content: `✅ تم تحديث حالة السكربت إلى: **${state}**`, ephemeral: true });
    }

    if (commandName === 'stats') {
      if (!isAdmin(interaction)) return interaction.reply({ content: '❌ ليس لديك صلاحية أدمن.', ephemeral: true });

      const now = Date.now();
      const activeKeys = Object.values(db.keys).filter(k => k.expiresAt > now).length;
      const totalBlacklisted = Object.keys(db.blacklisted).length;

      const embed = new EmbedBuilder()
        .setTitle('📈 إحصائيات البوت والأدمن')
        .addFields(
          { name: '🔑 الكودات النشطة حالياً', value: `${activeKeys}`, inline: true },
          { name: '📊 إجمالي الكودات المولدة', value: `${db.stats.totalGenerated}`, inline: true },
          { name: '🚫 المحظورين (Blacklisted)', value: `${totalBlacklisted}`, inline: true }
        )
        .setColor('#FFA500');

      return interaction.reply({ embeds: [embed], ephemeral: true });
    }
  }

  if (interaction.isButton()) {
    if (interaction.customId === 'get_key_direct') {
      if (db.blacklisted[interaction.user.id]) {
        return interaction.reply({ content: '❌ أنت محظور من استخدام البوت.', ephemeral: true });
      }

      const existingKey = db.keys[interaction.user.id];
      const now = Date.now();

      if (existingKey && existingKey.expiresAt > now) {
        const remaining = formatRemainingTime(existingKey.expiresAt - now);
        return interaction.reply({
          content: `⚠️ **لديك كود فعال بالفعل!**\n🔑 الكود الخاص بك: \`${existingKey.key}\`\n⏳ الوقت المتبقي على انتهائه: **${remaining}**`,
          ephemeral: true
        });
      }

      const isBooster = interaction.member && interaction.member.premiumSince;
      const durationHours = isBooster ? 24 * 7 : 24;
      const durationMs = durationHours * 60 * 60 * 1000;

      if (isBooster) {
        const newKey = generateRandomKey(true);
        db.keys[interaction.user.id] = {
          key: newKey,
          expiresAt: now + durationMs,
          hwid: null,
          lastReset: 0,
          isVip: true
        };
        db.stats.totalGenerated++;
        saveDB(db);

        if (interaction.guild) {
          const role = await ensureActiveRole(interaction.guild);
          if (role) await interaction.member.roles.add(role).catch(() => {});
        }

        return interaction.reply({
          content: `💎 **شكراً لدعمك السيرفر (Server Booster)!**\n🎉 تم منحك كود VIP خاص صالح لمدة **7 أيام**:\n\n🔑 الكود: \`${newKey}\``,
          ephemeral: true
        });
      } else {
        await interaction.reply({ content: '⏳ جاري توليد كود التفعيل الخاص بك... (يرجى الانتظار 5 ثوانٍ)', ephemeral: true });

        setTimeout(async () => {
          const newKey = generateRandomKey(false);
          db.keys[interaction.user.id] = {
            key: newKey,
            expiresAt: Date.now() + durationMs,
            hwid: null,
            lastReset: 0,
            isVip: false
          };
          db.stats.totalGenerated++;
          saveDB(db);

          if (interaction.guild) {
            const role = await ensureActiveRole(interaction.guild);
            if (role) await interaction.member.roles.add(role).catch(() => {});
          }

          const msgContent = `✅ **تم إنشاء كود التفعيل الخاص بك بنجاح!**\n\n🔑 الكود: \`${newKey}\`\n⏳ صالح لمدة: **24 ساعة**\n\n*(تذكير: الكود سري وخاص بك، لا تقم بمشاركته مع أحد)*`;

          try {
            await interaction.user.send(msgContent);
            await interaction.editReply({ content: '📩 **تم إرسال الكود في الخاص (DM) بنجاح!** تفقد رسائلك الخاصة.' });
          } catch (e) {
            await interaction.editReply({ content: `${msgContent}\n\n*(تعذر إرسال الرسالة في الخاص لأن خاصك مغلق)*` });
          }
        }, 5000);
      }
    }
  }
});

// تسجيل الدخول باستخدام التوكن المتاح
client.login(process.env.TOKEN || config.token);
