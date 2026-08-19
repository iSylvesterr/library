-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local v1 = {
    MediaKey = t.string,
    CommentId = t.string
};
v1.ClientCommentRecord = t.strictInterface({
    Id = v1.CommentId,
    UserId = t.number,
    CreatedAt = t.number,
    Message = t.string,
    ImageAssetId = t.optional(t.number),
    LikeCount = t.number,
    LikedByViewer = t.boolean
});
v1.PersistedCommentRecord = t.strictInterface({
    I = v1.CommentId,
    U = t.number,
    T = t.number,
    M = t.string,
    A = t.optional(t.number),
    L = t.number
});
v1.PersistedCommentPayload = t.strictInterface({
    V = t.number,
    U = t.number,
    N = t.number,
    C = t.array(v1.PersistedCommentRecord)
});
v1.CommentCountPayload = t.strictInterface({
    V = t.number,
    U = t.number,
    C = t.map(v1.MediaKey, t.number)
});
v1.CommentCountEnvelope = t.interface({
    V = t.number,
    U = t.number,
    C = t.table
});
v1.CommentPageRequest = t.strictInterface({
    MediaKey = v1.MediaKey,
    Cursor = t.optional(t.number),
    PageSize = t.optional(t.number)
});
v1.CommentPageResult = t.strictInterface({
    Ok = t.boolean,
    TotalCreatedCount = t.optional(t.number),
    Comments = t.optional(t.array(v1.ClientCommentRecord)),
    NextCursor = t.optional(t.number),
    Error = t.optional(t.string)
});
v1.CommentCountsRequest = t.strictInterface({
    MediaKeys = t.array(v1.MediaKey)
});
v1.CommentCountsResult = t.strictInterface({
    Ok = t.boolean,
    CountsByMediaKey = t.optional(t.map(v1.MediaKey, t.number)),
    Loaded = t.optional(t.boolean),
    Stale = t.optional(t.boolean),
    Error = t.optional(t.string)
});
v1.PostCommentRequest = t.strictInterface({
    MediaKey = v1.MediaKey,
    Message = t.optional(t.string),
    ImageAssetId = t.optional(t.number)
});
v1.PostCommentResult = t.strictInterface({
    Ok = t.boolean,
    Comment = t.optional(v1.ClientCommentRecord),
    Pending = t.optional(t.boolean),
    Error = t.optional(t.string)
});
v1.SetCommentLikeRequest = t.strictInterface({
    MediaKey = v1.MediaKey,
    CommentId = v1.CommentId,
    Liked = t.boolean
});
v1.SetCommentLikeResult = t.strictInterface({
    Ok = t.boolean,
    CommentId = t.optional(v1.CommentId),
    LikeCount = t.optional(t.number),
    Liked = t.optional(t.boolean),
    Delta = t.optional(t.number),
    Error = t.optional(t.string)
});

return v1;