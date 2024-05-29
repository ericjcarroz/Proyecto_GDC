  <div class="sidebar has-background-dark">
        <div class="sidebar-menu is-danger">
            <div class="menu">
                <ul class="menu-list">
                    <li>
                        <a href="/" class="is-active">
                            <span class="icon">
                                <i class="fab fa-slack"></i>
                            </span>
                            <span>
                                Dashboard
                            </span>
                        </a>
                    </li>
                </ul>
                <p class="menu-label">
                    templates
                </p>
                <hr class="dropdown-divider">
                <ul class="menu-list">
                    <li class="has-list-child">
                        <a>
                            <span class="icon">
                                <i class="fas fa-list-ul"></i>
                            </span>
                            <span>Pages</span>
                            <span class="icon is-pulled-right">
                                <i class="fas fa-angle-right"></i>
                            </span>
                        </a>
                        <ul>
                            <li><a href="/login.html">Login</a></li>
                            <li><a href="/register.html">Register</a></li>
                        </ul>
                    </li>
                    <li class="has-list-child">
                        <a>
                            <span class="icon">
                                <i class="fas fa-list-ul"></i>
                            </span>
                            <span>Components</span>
                            <span class="icon is-pulled-right">
                                <i class="fas fa-angle-right"></i>
                            </span>
                        </a>
                        <ul>
                            <li>
                                <a href="/widget.html">Widget</a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <script>    

    const navBurger = document.querySelector(".navbar-burger");
const sidebar = document.querySelector(".sidebar");
navBurger.addEventListener("click", function () {
    navBurger.classList.toggle("is-active");
    sidebar.classList.toggle("active");
});


</script>