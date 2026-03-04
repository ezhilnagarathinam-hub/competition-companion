import { Link, useLocation } from 'react-router-dom';
import { 
  LayoutDashboard, 
  Trophy, 
  FileQuestion, 
  Users, 
  Settings, 
  LogOut,
  ClipboardList,
  Zap
} from 'lucide-react';
import { useAdminAuth } from '@/lib/auth';

const navItems = [
  { path: '/admin', icon: LayoutDashboard, label: 'Dashboard' },
  { path: '/admin/competitions', icon: Trophy, label: 'Competitions' },
  { path: '/admin/questions', icon: FileQuestion, label: 'Questions' },
  { path: '/admin/students', icon: Users, label: 'Students' },
  { path: '/admin/results', icon: ClipboardList, label: 'Results' },
  { path: '/admin/settings', icon: Settings, label: 'Settings' },
];

export function AdminSidebar() {
  const location = useLocation();
  const { adminName, logout } = useAdminAuth();

  const isActive = (path: string) => {
    if (path === '/admin') {
      return location.pathname === '/admin';
    }
    return location.pathname.startsWith(path);
  };

  return (
    <aside className="fixed left-0 top-0 h-screen w-64 bg-card border-r border-border flex flex-col relative overflow-hidden">
      <div className="absolute inset-0 bg-gradient-to-b from-primary/5 to-transparent pointer-events-none" />
      
      <div className="p-6 border-b border-border relative z-10">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl gradient-primary flex items-center justify-center shadow-primary">
            <Zap className="w-5 h-5 text-primary-foreground" />
          </div>
          <div>
            <h1 className="font-bold text-sm text-foreground font-display">COMPETE ME</h1>
            <p className="text-xs text-muted-foreground">Control Center</p>
          </div>
        </div>
      </div>

      <nav className="flex-1 p-4 space-y-1 relative z-10">
        {navItems.map((item) => (
          <Link
            key={item.path}
            to={item.path}
            className={`admin-nav-link ${isActive(item.path) ? 'active' : ''}`}
          >
            <item.icon className="w-5 h-5" />
            <span>{item.label}</span>
          </Link>
        ))}
      </nav>

      <div className="p-4 border-t border-border relative z-10">
        <div className="flex items-center gap-3 px-4 py-3 mb-2 rounded-lg bg-primary/10">
          <div className="w-8 h-8 rounded-full bg-primary/20 flex items-center justify-center">
            <span className="text-sm font-bold text-primary font-display">
              {adminName?.charAt(0).toUpperCase()}
            </span>
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-sm font-bold text-foreground truncate font-display">{adminName}</p>
            <p className="text-xs text-muted-foreground">Administrator</p>
          </div>
        </div>
        <button 
          onClick={logout}
          className="admin-nav-link w-full text-destructive hover:bg-destructive/10 hover:text-destructive"
        >
          <LogOut className="w-5 h-5" />
          <span>Logout</span>
        </button>
      </div>
    </aside>
  );
}
