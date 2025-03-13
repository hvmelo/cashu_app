// Shared preferences keys

const currentMintKey = 'currentMint';
const userMintsKey = 'userMints';
const initialMintUrl = 'https://testnut.cashu.space';

/// The maximum length of a mint nickname.
const mintNicknameMaxLength = 50;

/// The regex pattern for valid characters in a mint nickname.
const mintNicknameValidCharRegex = r'^[a-zA-Z0-9\-_.]+$';

/// The maximum amount of a mint.
BigInt get mintAmountMax => BigInt.from(1000000000000000000);
