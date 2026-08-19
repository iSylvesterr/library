-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local v1 = {
    MediaKey = t.string,
    CountsByMediaLikeKey = t.map(t.string, t.number),
    LikerUserIds = t.array(t.integer)
};
v1.LikerUserIdsByMediaLikeKey = t.map(t.string, v1.LikerUserIds);
v1.MemberUserIdSet = t.map(t.string, t.boolean);
v1.MembersByMediaLikeKey = t.map(t.string, v1.MemberUserIdSet);
v1.MemberBucketsByMediaLikeKey = t.map(t.string, t.map(t.string, v1.MemberUserIdSet));
v1.MemberCountsByMediaLikeKey = t.map(t.string, t.number);
v1.OldestMemberBucketByMediaLikeKey = t.map(t.string, t.number);
v1.LikedTreadmillMedia = t.map(t.string, t.boolean);
v1.LikeSnapshot = t.strictInterface({
    CountsByMediaLikeKey = v1.CountsByMediaLikeKey,
    LikedTreadmillMedia = v1.LikedTreadmillMedia
});
v1.FriendLikeSnapshot = t.strictInterface({
    FriendLikeUserIdsByMediaLikeKey = v1.LikerUserIdsByMediaLikeKey
});
v1.FriendLikeSnapshotRequest = t.strictInterface({
    MediaKeys = t.optional(t.array(v1.MediaKey))
});
v1.LikeToggleResult = t.strictInterface({
    Ok = t.boolean,
    Liked = t.optional(t.boolean),
    Delta = t.optional(t.number),
    Count = t.optional(t.number),
    Error = t.optional(t.string)
});
v1.LikeToggleRequest = t.strictInterface({
    MediaKey = v1.MediaKey,
    Liked = t.boolean
});
v1.AggregateShardPayload = t.strictInterface({
    Version = t.number,
    UpdatedAt = t.number,
    Counts = v1.CountsByMediaLikeKey
});
v1.MemberShardPayload = t.strictInterface({
    Version = t.number,
    UpdatedAt = t.number,
    MembersByMediaLikeKey = t.optional(v1.MembersByMediaLikeKey),
    MemberBucketsByMediaLikeKey = t.optional(v1.MemberBucketsByMediaLikeKey),
    MemberCountsByMediaLikeKey = t.optional(v1.MemberCountsByMediaLikeKey),
    OldestMemberBucketByMediaLikeKey = t.optional(v1.OldestMemberBucketByMediaLikeKey)
});

return v1;