import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/settings_provider.dart';

class L10n {
  final String _lang;
  const L10n._(this._lang);

  static L10n of(BuildContext context) {
    final container = ProviderScope.containerOf(context);
    final lang = container.read(settingsProvider).language;
    return L10n._(lang);
  }

  String _t(String en, String es) => _lang == 'es' ? es : en;

  String get appTitle => 'World Cup 2026';
  String get tabHome => _t('Home', 'Inicio');
  String get tabFixture => _t('Fixture', 'Calendario');
  String get tabStandings => _t('Standings', 'Posiciones');
  String get tabTeams => _t('Teams', 'Equipos');
  String get tabMore => _t('More', 'Más');
  String get tabFavorites => _t('Favorites', 'Favoritos');
  String get tabSettings => _t('Settings', 'Configuración');
  String get liveMatches => _t('Live Matches', 'En Vivo');
  String get upcomingMatches => _t('Upcoming Matches', 'Próximos Partidos');
  String get recentResults => _t('Recent Results', 'Resultados Recientes');
  String get featuredNews => _t('Featured News', 'Noticias Destacadas');
  String get featuredTeams => _t('Featured Teams', 'Equipos Destacados');
  String get group => _t('Group', 'Grupo');
  String get legend => _t('Legend', 'Leyenda');
  String get qualified => _t('Qualified to Round of 16', 'Clasificado a Octavos');
  String get eliminated => _t('Eliminated', 'Eliminado');
  String get pos => _t('Pos', 'Pos');
  String get team => _t('Team', 'Equipo');
  String get byDate => _t('By Date', 'Por Fecha');
  String get byGroup => _t('By Group', 'Por Grupo');
  String get searchMatches => _t('Search matches...', 'Buscar partidos...');
  String get noMatchesFound => _t('No matches found', 'No se encontraron partidos');
  String get tryAdjusting => _t('Try adjusting your filters', 'Ajusta los filtros');
  String get today => _t('TODAY', 'HOY');
  String matchCount(int n) => n == 1 ? _t('1 match', '1 partido') : _t('$n matches', '$n partidos');
  String get noScheduled => _t('No matches scheduled', 'No hay partidos programados');
  String get searchTeams => _t('Search teams...', 'Buscar equipos...');
  String get noTeamsFound => _t('No teams found', 'No se encontraron equipos');
  String get all => _t('All', 'Todos');
  String get searchPlayers => _t('Search players...', 'Buscar jugadores...');
  String get noPlayersFound => _t('No players found', 'No se encontraron jugadores');
  String get appearance => _t('Appearance', 'Apariencia');
  String get darkMode => _t('Dark Mode', 'Modo Oscuro');
  String get useDarkTheme => _t('Use dark theme', 'Usar tema oscuro');
  String get language => _t('Language', 'Idioma');
  String get notifications => _t('Notifications', 'Notificaciones');
  String get pushNotifications => _t('Push Notifications', 'Notificaciones Push');
  String get receiveUpdates => _t('Receive match updates', 'Recibir actualizaciones de partidos');
  String get noData => _t('No data available', 'Sin datos disponibles');
  String get connectionError => _t('Connection error', 'Error de conexión');
  String get pullToRefresh => _t('Pull to refresh', 'Desliza para actualizar');
  String get goHome => _t('Go Home', 'Ir al Inicio');
  String get pageNotFound => _t('Page Not Found', 'Página no encontrada');
  String get noLive => _t('No live matches', 'No hay partidos en vivo');
  String get checkBack => _t('Check back during match time', 'Revisa durante los partidos');
  String get noUpcoming => _t('No upcoming matches', 'No hay próximos partidos');
  String get comingSoon => _t('Matches will appear here soon', 'Los partidos aparecerán pronto');
  String get noRecent => _t('No recent results', 'No hay resultados recientes');
  String get resultsSoon => _t('Results will appear after matches', 'Los resultados aparecerán después');
  String get noNews => _t('No news available', 'No hay noticias');
  String get stayTuned => _t('Stay tuned for updates', 'Próximas actualizaciones');
  String get knockoutTitle => _t('Knockout Stage', 'Eliminatorias');
  String get noKnockout => _t('No knockout matches yet', 'No hay eliminatorias aún');
  String get knockoutSoon => _t('Knockout matches will appear here', 'Las eliminatorias aparecerán aquí');
  String get settings => _t('Settings', 'Configuración');
  String get fixtures => _t('Fixtures', 'Calendario');
  String get standings => _t('Standings', 'Posiciones');
  String get players => _t('Players', 'Jugadores');
  String get stadiums => _t('Stadiums', 'Estadios');
  String get news => _t('News', 'Noticias');
}
