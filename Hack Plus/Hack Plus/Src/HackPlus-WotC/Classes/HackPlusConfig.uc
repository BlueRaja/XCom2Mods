class HackPlusConfig extends Object config(HackPlus);

var config bool RandomizeReward;
var config int HackPointRewardEasyOnSuccess;
var config int HackPointRewardOnSuccess;
var config int HackPointRewardEasyOnFail;
var config int HackPointRewardOnFail;
var config bool AlwaysSucceed;
var config bool FreeAction;
var config bool DiminishingReturns;
var config int DiminishingReturnsStartsAbove;

simulated function bool getDiminishingReturns()
{
	return DiminishingReturns;
}

simulated function int getDiminishingReturnsStartsAbove()
{
	return DiminishingReturnsStartsAbove;
}

simulated function bool getRandomizeReward()
{
	return RandomizeReward;
}

simulated function int getHackPointRewardEasyOnSuccess()
{
	return HackPointRewardEasyOnSuccess;
}

simulated function int getHackPointRewardOnSuccess()
{
	return HackPointRewardOnSuccess;
}

simulated function int getHackPointRewardEasyOnFail()
{
	return HackPointRewardEasyOnFail;
}

simulated function int getHackPointRewardOnFail()
{
	return HackPointRewardOnFail;
}

simulated function bool getAlwaysSucceed()
{
	return AlwaysSucceed;
}

simulated function bool getFreeAction()
{
	return FreeAction;
}