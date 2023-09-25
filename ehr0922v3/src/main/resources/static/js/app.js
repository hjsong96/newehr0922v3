function checkActiveclass(className){

  if(!!className){
    return { 'result' : true }
  }

  return { 'result' : false }
}

const sidebar_menu = document.querySelector('.sidebar__menu');
const sidebar_menu_lis = document.querySelectorAll('.sidebar__menu > li');

sidebar_menu.addEventListener('click', e =>{
  const className = e.target.parentNode.classList[0]

  const activeClass = checkActiveclass(className)
  if(activeClass['result']){
    e.target.parentNode.classList.remove("active");
    return
  }

  const selectMenu = e.target.parentNode;
  sidebar_menu_lis.forEach(item => {
    if(item === selectMenu){
      item.classList.add("active");
    }else{
      item.classList.remove("active");
    }

  });
})


const navbar = document.querySelector('#navbar');
navbar.addEventListener('click', e => {
  activeSidemenuFind()
})

const article = document.querySelector('#article');
article.addEventListener('click', e => {
  activeSidemenuFind()
})


function activeSidemenuFind(){
  const sidebar_menu_lis = document.querySelectorAll('.sidebar__menu > li')
  const activeItems = Array.from(sidebar_menu_lis).filter(item => item.classList.contains('active'));

  if(activeItems.length == 0 ){
    return
  }

  activeItems[0].classList.remove("active");

}




