import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class EntityStateConfig {
  final String activeLabel;
  final String archivedLabel;
  final String deletedLabel;
  final String reportedLabel;
  final String restoreFromArchivedAction;
  final String restoreFromDeletedAction;
  final String restoreFromArchivedSuccessMessage;
  final String restoreFromDeletedSuccessMessage;
  final String deleteActionText;
  final String archiveActionText;
  final String deleteSuccessMessage;
  final String archiveSuccessMessage;

  const EntityStateConfig({
    required this.activeLabel,
    required this.archivedLabel,
    required this.deletedLabel,
    required this.reportedLabel,
    required this.restoreFromArchivedAction,
    required this.restoreFromDeletedAction,
    required this.restoreFromArchivedSuccessMessage,
    required this.restoreFromDeletedSuccessMessage,
    required this.deleteActionText,
    required this.archiveActionText,
    required this.deleteSuccessMessage,
    required this.archiveSuccessMessage,
  });
}

class EntityStateManager {
  static const Map<AppType, Map<EntityType, EntityStateConfig>> _configs = {
    AppType.cac: {
      EntityType.event: EntityStateConfig(
        activeLabel: 'Published',
        archivedLabel: 'Unpublished',
        deletedLabel: 'Deleted',
        reportedLabel: 'Reported',
        restoreFromArchivedAction: 'Publish',
        restoreFromDeletedAction: 'Restore',
        restoreFromArchivedSuccessMessage: 'Successfully published event',
        restoreFromDeletedSuccessMessage: 'Successfully restored event',
        deleteActionText: 'Delete',
        archiveActionText: 'Archive',
        deleteSuccessMessage: 'Event deleted successfully',
        archiveSuccessMessage: 'Event archived successfully',
      ),
      EntityType.profile: EntityStateConfig(
        activeLabel: 'Active',
        archivedLabel: 'Pending Approval',
        deletedLabel: 'Blocked',
        reportedLabel: 'Reported',
        restoreFromArchivedAction: 'Approve',
        restoreFromDeletedAction: 'Unblock',
        restoreFromArchivedSuccessMessage: 'Successfully approved profile',
        restoreFromDeletedSuccessMessage: 'Successfully unblocked profile',
        deleteActionText: 'Block',
        archiveActionText: 'Pending Approval',
        deleteSuccessMessage: 'Profile blocked successfully',
        archiveSuccessMessage: 'Profile set to pending approval successfully',
      ),
      EntityType.photo: EntityStateConfig(
        activeLabel: 'Public',
        archivedLabel: 'Private',
        deletedLabel: 'Hidden',
        reportedLabel: 'Reported',
        restoreFromArchivedAction: 'Make Public',
        restoreFromDeletedAction: 'Make Public',
        restoreFromArchivedSuccessMessage: 'Successfully made photo public',
        restoreFromDeletedSuccessMessage: 'Successfully made photo public',
        deleteActionText: 'Hide',
        archiveActionText: 'Make Public',
        deleteSuccessMessage: 'Photo hidden successfully',
        archiveSuccessMessage: 'Photo made public successfully',
      ),
    },
    AppType.loopjam: {
      EntityType.event: EntityStateConfig(
        activeLabel: 'Published',
        archivedLabel: 'Unpublished',
        deletedLabel: 'Deleted',
        reportedLabel: 'Reported',
        restoreFromArchivedAction: 'Publish',
        restoreFromDeletedAction: 'Restore',
        restoreFromArchivedSuccessMessage: 'Successfully published event',
        restoreFromDeletedSuccessMessage: 'Successfully restored event',
        deleteActionText: 'Delete',
        archiveActionText: 'Archive',
        deleteSuccessMessage: 'Event deleted successfully',
        archiveSuccessMessage: 'Event archived successfully',
      ),
      EntityType.photo: EntityStateConfig(
        activeLabel: 'Approved',
        archivedLabel: 'Pending Approval',
        deletedLabel: 'Deleted',
        reportedLabel: 'Reported',
        restoreFromArchivedAction: 'Approve',
        restoreFromDeletedAction: 'Restore',
        restoreFromArchivedSuccessMessage: 'Successfully approved photo',
        restoreFromDeletedSuccessMessage: 'Successfully restored photo',
        deleteActionText: 'Delete',
        archiveActionText: 'Pending Approval',
        deleteSuccessMessage: 'Photo deleted successfully',
        archiveSuccessMessage: 'Photo archived successfully',
      ),
    },
    AppType.lm: {
       EntityType.photo: EntityStateConfig(
        activeLabel: 'Active',
        archivedLabel: 'Archived',
        deletedLabel: 'Deleted',
        reportedLabel: 'Reported',
        restoreFromArchivedAction: 'Restore',
        restoreFromDeletedAction: 'Restore',
        restoreFromArchivedSuccessMessage: 'Successfully restored photo',
        restoreFromDeletedSuccessMessage: 'Successfully restored photo',
        deleteActionText: 'Delete',
        archiveActionText: 'Archive',
        deleteSuccessMessage: 'Photo deleted successfully',
        archiveSuccessMessage: 'Photo archived successfully',
      ),
    },
    AppType.mis: {
      EntityType.profile: EntityStateConfig(
        activeLabel: 'Active',
        archivedLabel: 'Pending Approval',
        deletedLabel: 'Blocked',
        reportedLabel: 'Reported',
        restoreFromArchivedAction: 'Approve',
        restoreFromDeletedAction: 'Unblock',
        restoreFromArchivedSuccessMessage: 'Successfully approved profile',
        restoreFromDeletedSuccessMessage: 'Successfully unblocked profile',
        deleteActionText: 'Block',
        archiveActionText: 'Pending Approval',
        deleteSuccessMessage: 'Profile blocked successfully',
        archiveSuccessMessage: 'Profile set to pending approval successfully',
      ),
    },
    AppType.lvc: {
      EntityType.profile: EntityStateConfig(
        activeLabel: 'Active',
        archivedLabel: 'Pending Approval',
        deletedLabel: 'Blocked',
        reportedLabel: 'Reported',
        restoreFromArchivedAction: 'Approve',
        restoreFromDeletedAction: 'Unblock',
        restoreFromArchivedSuccessMessage: 'Successfully approved profile',
        restoreFromDeletedSuccessMessage: 'Successfully unblocked profile',
        deleteActionText: 'Block',
        archiveActionText: 'Pending Approval',
        deleteSuccessMessage: 'Profile blocked successfully',
        archiveSuccessMessage: 'Profile set to pending approval successfully',
      ),
    },
    AppType.events121: {
      EntityType.profile: EntityStateConfig(
        activeLabel: 'Active',
        archivedLabel: 'Pending Approval',
        deletedLabel: 'Blocked',
        reportedLabel: 'Reported',
        restoreFromArchivedAction: 'Approve',
        restoreFromDeletedAction: 'Unblock',
        restoreFromArchivedSuccessMessage: 'Successfully approved profile',
        restoreFromDeletedSuccessMessage: 'Successfully unblocked profile',
        deleteActionText: 'Block',
        archiveActionText: 'Pending Approval',
        deleteSuccessMessage: 'Profile blocked successfully',
        archiveSuccessMessage: 'Profile set to pending approval successfully',
      ),
    },
    AppType.boilerplate: {
      EntityType.profile: EntityStateConfig(
        activeLabel: 'Approved',
        archivedLabel: 'Pending Approval',
        deletedLabel: 'Blocked',
        reportedLabel: 'Reported',
        restoreFromArchivedAction: 'Approve',
        restoreFromDeletedAction: 'Unblock',
        restoreFromArchivedSuccessMessage: 'Successfully approved profile',
        restoreFromDeletedSuccessMessage: 'Successfully unblocked profile',
        deleteActionText: 'Block',
        archiveActionText: 'Pending Approval',
        deleteSuccessMessage: 'Profile blocked successfully',
        archiveSuccessMessage: 'Profile set to pending approval successfully',
      ),
    },
  };

  static EntityStateConfig? _getConfig(EntityType entityType) {
    return _configs[ProjectConfig.appType]?[entityType];
  }

  static String getStateLabel(EntityType entityType, EntityState entityState) {
    final config = _getConfig(entityType);
    if (config == null) {
      return _getDefaultLabel(entityState);
    }
    switch (entityState) {
      case EntityState.active:
        return config.activeLabel;
      case EntityState.archived:
        return config.archivedLabel;
      case EntityState.deleted:
        return config.deletedLabel;
      case EntityState.reported:
        return config.reportedLabel;
      case EntityState.myEntities:
        return 'My ${entityType.name}';
      default:
        return 'Unknown State label';
    }
  }

  static String getRestoreActionText(
      EntityType entityType, BaseEntity? baseEntity) {
    final config = _getConfig(entityType);
    if (config == null || baseEntity == null) {
      return 'Restore';
    }
    switch (_getCurrentEntityState(baseEntity)) {
      case EntityState.active:
        return 'N/A'; // No restore action needed for active entities
      case EntityState.archived:
        return config.restoreFromArchivedAction;
      case EntityState.deleted:
        return config.restoreFromDeletedAction;
      default:
        return 'Unknown restore action';
    }
  }

  static String getDeleteActionText(
      EntityType entityType, BaseEntity? baseEntity) {
    final config = _getConfig(entityType);
    if (config == null || baseEntity == null) {
      return 'Delete';
    }
    switch (_getCurrentEntityState(baseEntity)) {
      case EntityState.active:
        return config.deleteActionText;
      case EntityState.archived:
        return config.deleteActionText;
      case EntityState.deleted:
        return 'N/A';
      default:
        return 'Unknown delete action';
    }
  }

  static String getArchiveActionText(
      EntityType entityType, BaseEntity? baseEntity) {
    final config = _getConfig(entityType);
    if (config == null || baseEntity == null) {
      return 'Archive';
    }
    switch (_getCurrentEntityState(baseEntity)) {
      case EntityState.active:
        return config.archiveActionText;
      case EntityState.archived:
        return 'N/A';
      case EntityState.deleted:
        return 'N/A';
      default:
        return 'Unknown archive action';
    }
  }

  static String getRestoreSuccessMessage(
      EntityType entityType, BaseEntity baseEntity) {
    final currentState = _getCurrentEntityState(baseEntity);
    final config = _getConfig(entityType);
    if (config == null) {
      return 'Successfully restored ${entityType.name}';
    }

    switch (currentState) {
      case EntityState.active:
        return 'Entity is already active';
      case EntityState.archived:
        return config.restoreFromArchivedSuccessMessage;
      case EntityState.deleted:
        return config.restoreFromDeletedSuccessMessage;
      default:
        return 'Unknown restore success message';
    }
  }

  static String getDeleteSuccessMessage(
      EntityType entityType, BaseEntity baseEntity) {
    final config = _getConfig(entityType);
    if (config == null) {
      return 'Successfully deleted ${entityType.name}';
    }
    return config.deleteSuccessMessage;
  }

  static String getArchiveSuccessMessage(
      EntityType entityType, BaseEntity baseEntity) {
    final config = _getConfig(entityType);
    if (config == null) {
      return 'Successfully archived ${entityType.name}';
    }
    return config.archiveSuccessMessage;
  }

  static EntityState _getCurrentEntityState(BaseEntity baseEntity) {
    if (baseEntity.isActive) {
      return EntityState.active;
    } else if (baseEntity.isArchived) {
      return EntityState.archived;
    } else if (baseEntity.isDeleted == true) {
      return EntityState.deleted;
    } else {
      return EntityState.active; // Default fallback
    }
  }

  static String _getDefaultLabel(EntityState state) {
    switch (state) {
      case EntityState.active:
        return 'Active';
      case EntityState.archived:
        return 'Archived';
      case EntityState.deleted:
        return 'Deleted';
      case EntityState.reported:
        return 'Reported';
      default:
        return 'Unknown State';
    }
  }
}
