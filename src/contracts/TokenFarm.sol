// TokenFarm.sol
pragma solidity ^0.5.0;

import "./DappToken.sol";
import "./MockDaiToken.sol";

contract TokenFarm {
    string public name = "Dapp Token Farm";
    DappToken public dappToken;
    DaiToken public daiToken;

    // 7. これまでにステーキングを行ったすべてのアドレスを追跡する配列を作成
    address[] public stakers;

    // 4.投資家のアドレスと彼らのステーキングしたトークンの量を紐づける mapping を作成
    mapping(address => uint256) public stakingBalance;

    // 6. 投資家のアドレスをもとに彼らがステーキングを行ったか否かを紐づける mapping を作成
    mapping(address => bool) public hasStaked;

    // 10. 投資家の最新のステイタスを記録するマッピングを作成
    mapping(address => bool) public isStaking;

    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
    }

    // 1.ステーキング機能を作成する
    function stakeTokens(uint256 _amount) public {
        // 2. ステーキングされるトークンが0以上あることを確認
        require(_amount > 0, "amount can't be 0");
        // 3. 投資家のトークンを TokenFarm.sol に移動させる
        daiToken.transferFrom(msg.sender, address(this), _amount);

        // 5. ステーキングされたトークンの残高を更新する
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        // 8. 投資家がまだステークしていない場合のみ、彼らをstakers配列に追加する
        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }
        // 9. ステーキングステータスの更新
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }
}
