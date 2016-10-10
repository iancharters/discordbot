defmodule Discordbot.Events do
  def event do
    %{
      :ready                        => "READY",
      :resumed                      => "RESUMED",
      :channel_create               => "CHANNEL_CREATE",
      :channel_update               => "CHANNEL_UPDATE",
      :channel_delete               => "CHANNEL_DELETE",
      :guild_create                 => "GUILD_CREATE",
      :guild_update                 => "GUILD_UPDATE",
      :guild_delete                 => "GUILD_DELETE",
      :guild_ban_add                => "GUILD_BAN_ADD",
      :guild_emjoi_update           => "GUILD_EMOJI_UPDATE",
      :guild_interrogations_update  => "GUILD_INTERROGATIONS_UPDATE",
      :guild_member_add             => "GUILD_MEMBER_ADD",
      :guild_member_remove          => "GUILD_MEMBER_REMOVE",
      :guild_member_update          => "GUILD_MEMBER_UPDATE",
      :guild_member_chunk           => "GUILD_MEMBER_CHUNK",
      :guild_role_create            => "GUILD_ROLE_CREATE",
      :guild_role_update            => "GUILD_ROLE_UPDATE",
      :guild_role_delete            => "GUILD_ROLE_DELETE",
      :message_create               => "MESSAGE_CREATE",
      :message_update               => "MESSAGE_UPDATE",
      :message_delete               => "MESSAGE_DELETE",
      :message_delete_bulk          => "MESSAGE_DELETE_BULK",
      :presence_update              => "PRESENCE_UPDATE",
      :typing_start                 => "TYPING_START",
      :user_settings_update         => "USER_SETTINGS_UPDATE",
      :user_ypdate                  => "USER_UPDATE",
      :voice_state_update           => "VOICE_STATE_UPDATE",
      :voice_server_update          => "VOICE_SERVER_UPDATE",

    }
  end

  def opcodes do
    %{
      :dispatch               => 0,
      :heartbeat              => 1,
      :identify               => 2,
      :status_update          => 3,
      :voice_state_update     => 4,
      :voice_server_ping      => 5,
      :resume                 => 6,
      :reconnect              => 7,
      :request_guild_members  => 8,
      :invalid_session        => 9
    }
  end
end
