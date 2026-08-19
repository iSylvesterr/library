-- Decompiled with Potassium's decompiler.

return {
    Name = "qamailstale",
    Description = "QA: stage a backdated OutboxPending entry on YOUR profile targeting a recipient, then REJOIN to trigger the outbox retry. Drop flag off = re-delivered (recipient gets test mail); on = dropped. FlaggedPet=true stages a DupeFlagged Bunny instead of seeds (tests the claim-time dupe block). Watch PlayerMailOutboxRetry / mailforensics. Dev place only.",
    Group = "DefaultAdmin",
    Aliases = {},
    Args = { {
            Type = "player",
            Name = "Recipient",
            Description = "Player whose mailbox the staged gift targets (pick your second QA account; must differ from you)."
        }, {
            Type = "number",
            Name = "AgeHours",
            Description = "How old the staged entry should read (default: OutboxRetryMaxAgeHours + 1, i.e. just past the stale cutoff). Use 0 for a fresh entry that always re-delivers.",
            Optional = true
        }, {
            Type = "boolean",
            Name = "FlaggedPet",
            Description = "true = stage a DupeFlagged Bunny pet instead of seeds. After re-delivery, claiming it is BLOCKED while Game.Security.DupeDetection.BlockFlaggedTransfers is on (recipient can Decline to clean up).",
            Optional = true
        } }
};