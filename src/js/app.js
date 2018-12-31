var ID_ARRAY;
var HEROES_SIZE;
App = {
  web3Provider: null,
  contracts: {},
  init: async function() {
    console.log("init");
    $.getJSON('../candidates.json', function(data) {
      var petsRow = $('#petsRow');
      var petTemplate = $('#petTemplate');
      ID_ARRAY = new Array(data.length);
      HEROES_SIZE = data.length;
      for (i = 0; i < data.length; i ++) {
        petTemplate.find('.name').text(data[i].name);
        petTemplate.find('img').attr('src', data[i].picture);
        petTemplate.find('.count').text(data[i].count);
        petTemplate.find('.btn-vote').attr('data-id', data[i].id);
        petsRow.append(petTemplate.html());
        ID_ARRAY[i] = data[i].id;
      }
    });
    return await App.initWeb3();
  },

  initWeb3: async function() {
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
      $.getJSON('Ballot.json', function(data) {
      var AdoptionArtifact = data;
      App.contracts.Adoption = TruffleContract(AdoptionArtifact);
      App.contracts.Adoption.setProvider(App.web3Provider);
      return App.markVoted();
    });
    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-vote', App.handleVote);
  },


  handleVote: function(event) {
    event.preventDefault();
    var select_id = parseInt($(event.target).data('id'));
    var heroId = ID_ARRAY[select_id];
    var voteInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
    
      var account = accounts[0];
    
      App.contracts.Adoption.deployed().then(function(instance) {
        voteInstance = instance;
        return voteInstance.vote(heroId, {from: account});
      }).then(function(result) {
        return App.markVoted();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  
  },

  markVoted: function(adopters, account) {
    console.log("markVoted");
    var voteInstance;

    App.contracts.Adoption.deployed().then(function(instance) {
      voteInstance = instance;

      var isVoted = voteInstance.isVoted.call();
      console.log(isVoted);
      return isVoted;
    }).then(function(isVoted) {
      if (isVoted) {
        for(i = 0; i < HEROES_SIZE; i++) {
          $('.panel-candidates').eq(i).find('.btn-vote').text('已投票').attr('disabled', true);
        }
      }
    });

    App.contracts.Adoption.deployed().then(function(instance) {
      voteInstance = instance;
      var datas = voteInstance.getCandidates.call();
      console.log(datas);
      return datas;
    }).then(function(datas) {
      var num = datas[0];
      var name = datas[1];
      var count = datas[2];

      for(i = 0; i < num.length; i++) {
        for(j = 0; j < num.length-i-1; j++) {
          var a = parseInt(count[j].c[0]);
          var b = parseInt(count[j + 1].c[0]);
          if(a < b) {
            [num[j].c[0], num[j + 1].c[0]] = [num[j+1].c[0], num[j].c[0]];
            [name[j], name[j + 1]] = [name[j+1], name[j]];
            [count[j].c[0], count[j + 1].c[0]] = [count[j + 1].c[0], count[j].c[0]];
          }
        }
      }
      $.getJSON('Ballot.json', function(data) {
        for (i = 0; i < num.length; i++) {
          var id = parseInt(num[i].c[0]);
          ID_ARRAY[i] = heroId;
          $('.candidates-heroes').eq(i).find('.count').text(count[i].c[0]);
          $('.candidates-heroes').eq(i).find('.img-center').attr('src', data[id].picture);
          $('.candidates-heroes').eq(i).find('.hero-name').text(data[id].name);
        }
      });
      
    });
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
