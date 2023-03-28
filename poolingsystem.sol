pragma solidity ^0.8.11;
contract pool {
    address public owner ;
    uint curent_pool =0;
    
    struct typepool{
        string question;
        string[] choices;
        uint [] votecount;
        uint creation_time ;
    }
    struct type_vote{
        uint poll;
        uint chosen;
        bool exist  ;
    }
    
    string  public winner;
    mapping(address=>type_vote) voters;
    type_vote[] votes;
    typepool[]  pools;
    string public question_asked;
    string []public choices_asked;
    constructor (){
        owner=msg.sender;
    }
    modifier onlyowner(){
        require(msg.sender==owner,"only owner can create pools");
        _;

    }
    event creation  ( uint nbpoolscreated );
    event voteing (uint thepoolnbr ,string option_chosen ,address voteraddr);
    
    


    function createpool(string memory _question, string[] memory _choices) onlyowner public {
    
    typepool memory newpool;
    newpool.question=_question;
    newpool.choices=_choices;
    newpool.creation_time=block.timestamp;
    newpool.votecount = new uint[](_choices.length);
    for (uint i = 0; i < _choices.length; i++) {
        newpool.votecount[i]=0;
    }
    pools.push(newpool);
    emit creation(curent_pool);
    curent_pool++;
}

    function getpool(uint poolnb) public {
    question_asked = pools[poolnb].question;
    choices_asked = pools[poolnb].choices;
}
modifier onlyonce (uint nbrpool) {
    require(voters[msg.sender].exist==false||voters[msg.sender].poll!=nbrpool,"you already voted");
    _;
}
modifier intime (uint nbpool) {
    require(pools[nbpool].creation_time+5>block.timestamp,"time for voting is over");
    _;
}

    function voting  (uint poolnbr,uint _choice_picked)onlyonce(poolnbr) intime(poolnbr)  public{
        
        
        type_vote memory  vote;//creating a vote 
        vote.poll=poolnbr;
        vote.chosen=_choice_picked;
        vote.exist=true;
        votes.push(vote);//adding the vite to the arrat of votes
        voters[msg.sender]=vote;//adding the vote corresponding to the voter
        pools[poolnbr].votecount[_choice_picked]++;
        emit voteing (poolnbr,pools[poolnbr].choices[_choice_picked],msg.sender);

    }
    function getwinner(uint the_pool)public returns(  string memory ){
        uint max=pools[the_pool].votecount[0];
        uint wining_choise;
        for (uint i=0;i<pools[the_pool].choices.length;i++){
            if(pools[the_pool].votecount[i]>max){
                max=pools[the_pool].votecount[i];
                wining_choise=i;
                
            }
            
        }
        winner=pools[the_pool].choices[wining_choise];
        return winner;
       
    }
}