-- Decompiled with Potassium's decompiler.

local Conversions = require(script.Conversions);
local u1 = {};
u1.__index = u1;
u1.C = 299792458;
u1.R = 8.314;
u1.GravityAcceleration = 9.8;
u1.Avogadro = 6.0221417900000006e23;
u1.Conversions = Conversions;

function u1.getVelocityAtTime(p2, p3, p4) -- Line: 113
    return p2 + p3 * p4;
end;

function u1.getInitialVelocity(p5, p6, p7) -- Line: 121
    return p5 - p6 * p7;
end;

function u1.getAcceleration(p8, p9, p10) -- Line: 129
    return (p9 - p8) / p10;
end;

function u1.getTimeSinceInitialVelocity(p11, p12, p13) -- Line: 137
    return (p12 - p11) / p13;
end;

function u1.getDistanceAtTime(p14, p15, p16) -- Line: 145
    return p16 * (p14 + p15) / 2;
end;

function u1.getTimeAtDistance(p17, p18, p19) -- Line: 153
    return p19 / ((p17 + p18) / 2);
end;

function u1.getInitialVelocityFromDistance(p20, p21, p22) -- Line: 157
    return p22 * p20 * 2 - p21;
end;

function u1.getVelocityFromDistance(p23, p24, p25) -- Line: 165
    return p25 * p23 * 2 - p24;
end;

function u1.getDistanceAtTimeFromInitialVelocityAndAcceleration(p26, p27, p28) -- Line: 173
    return p27 * p26 + 0.5 * p28 * p26 ^ 2;
end;

function u1.getInitialVelocityAtTimeFromDistanceAndAcceleration(p29, p30, p31) -- Line: 181
    return (p30 - 0.5 * p31 * p29 ^ 2) / p29;
end;

function u1.getTimeAtDistanceFromInitialVelocityAndAcceleration(p32, p33, p34) -- Line: 189
    return (p33 - p32) * 2 / p34;
end;

function u1.getAccelerationAtDistanceFromInitialVelocityAndTime(p35, p36, p37) -- Line: 197
    return (p36 - p35 * p37) * 2 / p37 ^ 2;
end;

function u1.getVelocityAtDistanceFromInitialVelocityAndAcceleration(p38, p39, p40) -- Line: 205
    return (p38 ^ 2 + 2 * p40 * p39) ^ 0.5;
end;

function u1.getInitialVelocityAtDistanceFromVelocityAndAcceleration(p41, p42, p43) -- Line: 213
    return (p41 ^ 2 - 2 * p43 * p42) ^ 0.5;
end;

function u1.getDistanceAtVelocityFromInitialVelocityAndAcceleration(p44, p45, p46) -- Line: 221
    return (p44 ^ 2 - p45 ^ 2) / (2 * p46);
end;

function u1.getAccelerationAtVelocityFromInitialVelocityAndDistance(p47, p48, p49) -- Line: 229
    return (p47 ^ 2 - p48 ^ 2) / (2 * p49);
end;

function u1.getForce(p50, p51) -- Line: 237
    return p50 * p51;
end;

function u1.getMassFromForce(p52, p53) -- Line: 241
    return p52 / p53;
end;

function u1.getAccelerationFromForce(p54, p55) -- Line: 245
    return p54 / p55;
end;

function u1.getKineticEnergy(p56, p57) -- Line: 249
    return 0.5 * p56 * p57 ^ 2;
end;

function u1.getMassFromKineticEnergyAndVelocity(p58, p59) -- Line: 253
    return 2 * p59 / p58 ^ 2;
end;

function u1.getVelocityFromKineticEnergyAndMass(p60, p61) -- Line: 257
    return (p61 * 2 / p60) ^ 0.5;
end;

function u1.getMomentum(p62, p63) -- Line: 261
    return p62 * p63;
end;

function u1.getVelocityFromMomentumAndMass(p64, p65) -- Line: 265
    return p65 / p64;
end;

function u1.getMassFromMomentumAndVelocity(p66, p67) -- Line: 269
    return p67 / p66;
end;

function u1.getWork(p68, p69) -- Line: 273
    return p68 * p69;
end;

function u1.getForceFromWorkAndDistance(p70, p71) -- Line: 277
    return p70 / p71;
end;

function u1.getDistanceFromWorkAndForce(p72, p73) -- Line: 281
    return p72 / p73;
end;

function u1.getPower(p74, p75) -- Line: 285
    return p74 / p75;
end;

function u1.getPowerFromForceAndVelocity(p76, p77) -- Line: 289
    return p76 * p77;
end;

function u1.getVelocityFromPowerAndForce(p78, p79) -- Line: 293
    return p79 / p78;
end;

function u1.getForceFromPowerAndVelocity(p80, p81) -- Line: 297
    return p81 / p80;
end;

function u1.getWorkFromPowerAndTime(p82, p83) -- Line: 301
    return p82 * p83;
end;

function u1.getTimeFromPowerAndWork(p84, p85) -- Line: 305
    return p85 / p84;
end;

function u1.getVoltage(p86, p87) -- Line: 309
    return p86 * p87;
end;

function u1.getResistance(p88, p89) -- Line: 313
    return p88 / p89;
end;

function u1.getCurrent(p90, p91) -- Line: 317
    return p90 / p91;
end;

function u1.getDragForce(p92, p93, p94, p95) -- Line: 321
    return 0.5 * p92 * p93 ^ 2 * p95 * p94;
end;

function u1.getDragCoefficient(p96, p97, p98, p99) -- Line: 330
    return p99 / (0.5 * p96 * p97 ^ 2 * p98);
end;

function u1.getDragArea(p100, p101, p102, p103) -- Line: 339
    return p103 / (0.5 * p100 * p101 ^ 2 * p102);
end;

function u1.getDragVelocity(p104, p105, p106, p107) -- Line: 348
    return (p107 / (0.5 * p104 * p106 * p105)) ^ 0.5;
end;

function u1.getDragFluidDensity(p108, p109, p110, p111) -- Line: 357
    return p111 / (p110 * 0.5 * p108 ^ 2 * p110);
end;

function u1.getFrictionForce(p112, p113) -- Line: 366
    return p112 * p113;
end;

function u1.getFrictionCoefficient(p114, p115) -- Line: 370
    return p114 / p115;
end;

function u1.getFrictionNormalForce(p116, p117) -- Line: 374
    return p116 / p117;
end;

function u1.getPressureFromAreaAndForce(p118, p119) -- Line: 378
    return p118 / p119;
end;

function u1.getPressureFromVolumeAndTemperatureAndAtoms(p120, p121, p122) -- Line: 382
    -- upvalues: u1 (copy)
    return p121 * u1.R * p122 / p120;
end;

function u1.getTemperatureFromVolumeAndPressureAndAtoms(p123, p124, p125) -- Line: 390
    -- upvalues: u1 (copy)
    return p125 * p123 / (p124 * u1.R);
end;

function u1.getVolumeFromTemperatureAndPressureAndAtoms(p126, p127, p128) -- Line: 398
    -- upvalues: u1 (copy)
    return p126 * u1.R * p128 / p127;
end;

function u1.getAtomCountFromTemperatureAndPressureAndVolume(p129, p130, p131) -- Line: 406
    -- upvalues: u1 (copy)
    return p130 * p129 / (u1.R * p131);
end;

function u1.getHeatEnergy(p132, p133, p134) -- Line: 414
    return p132 * p133 * p134;
end;

function u1.getHeatCapacity(p135, p136, p137) -- Line: 418
    return p136 / (p135 * p137);
end;

function u1.getDeltaTemperature(p138, p139, p140) -- Line: 422
    return p139 / (p138 * p140);
end;

function u1.getMassFromDeltaTemperatureAndHeatEnergyAndHeatCapacity(p141, p142, p143) -- Line: 426
    return p142 / (p141 * p143);
end;

return u1;